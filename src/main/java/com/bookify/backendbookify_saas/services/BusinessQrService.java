package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.entities.Business;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.util.EnumMap;
import java.util.Map;
import javax.imageio.ImageIO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class BusinessQrService {

    private static final String FIXED_QR_LOGO_PATH = "classpath:static/assets/KayedniLogo.png";

    private final Cloudinary cloudinary;
    private final ResourceLoader resourceLoader;

    @Value("${business.qr.image-size:1024}")
    private int imageSize;

    @Value("${business.qr.logo-scale-ratio:0.2}")
    private double logoScaleRatio;

    @Value("${business.qr.foreground-color:#000000}")
    private String foregroundColor;

    @Value("${business.qr.background-color:#FFFFFF}")
    private String backgroundColor;

    @Value("${business.qr.frontend-base-url:http://localhost:3000}")
    private String frontendBaseUrl;

    @Value("${business.qr.cloudinary-folder:Bookify/business-qr}")
    private String cloudinaryFolder;

    public void regenerateForBusiness(Business business, String triggerSource) {
        if (business == null || business.getId() == null) {
            throw new IllegalArgumentException("Business and business id are required for QR generation");
        }

        String targetUrl = buildTargetUrl(business);
        String publicId = "business-" + business.getId();

        try {
            byte[] qrPng = generateBrandedQrPng(targetUrl);

            Map<?, ?> uploadResult = cloudinary.uploader().upload(
                    qrPng,
                    ObjectUtils.asMap(
                            "folder", cloudinaryFolder,
                            "public_id", publicId,
                            "overwrite", true,
                            "resource_type", "image"
                    )
            );

            Object secureUrlObj = uploadResult.get("secure_url");
            if (secureUrlObj == null) {
                throw new IllegalStateException("Cloudinary upload succeeded but secure_url is missing");
            }

            business.setQrCodeUrl(secureUrlObj.toString());
            business.setQrUpdatedAt(LocalDateTime.now());

            log.info(
                    "Business QR generated: businessId={}, triggerSource={}, targetUrl={}, publicId={}"
                    , business.getId(), triggerSource, targetUrl, cloudinaryFolder + "/" + publicId
            );
        } catch (Exception ex) {
            log.error(
                    "Business QR generation failed: businessId={}, triggerSource={}, targetUrl={}, message={}"
                    , business.getId(), triggerSource, targetUrl, ex.getMessage(), ex
            );
            throw new IllegalStateException("Unable to generate business QR code", ex);
        }
    }

    private String buildTargetUrl(Business business) {
        String slug = slugifyBusinessName(business.getName());
        String normalizedBase = frontendBaseUrl != null ? frontendBaseUrl.trim() : "";

        if (normalizedBase.endsWith("/")) {
            normalizedBase = normalizedBase.substring(0, normalizedBase.length() - 1);
        }

        if (normalizedBase.isBlank()) {
            normalizedBase = "http://localhost:3000";
        }

        return normalizedBase + "/business/" + slug + "-" + business.getId();
    }

    private String slugifyBusinessName(String value) {
        if (value == null || value.isBlank()) {
            return "business";
        }

        String normalized = Normalizer.normalize(value.toLowerCase(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .trim()
                .replaceAll("[^\\w\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-", "")
                .replaceAll("-$", "");

        return normalized.isBlank() ? "business" : normalized;
    }

    private byte[] generateBrandedQrPng(String targetUrl) throws Exception {
        int safeSize = Math.max(imageSize, 256);

        Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
        hints.put(EncodeHintType.CHARACTER_SET, StandardCharsets.UTF_8.name());
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.MARGIN, 2);

        BitMatrix matrix = new MultiFormatWriter().encode(targetUrl, BarcodeFormat.QR_CODE, safeSize, safeSize, hints);

        MatrixToImageConfig imageConfig = new MatrixToImageConfig(
                parseHexColor(foregroundColor, Color.BLACK).getRGB(),
                parseHexColor(backgroundColor, Color.WHITE).getRGB()
        );

        BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(matrix, imageConfig);

        BufferedImage logo = readLogoSafely();
        if (logo != null) {
            overlayLogo(qrImage, logo);
        }

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ImageIO.write(qrImage, "PNG", output);
        return output.toByteArray();
    }

    private BufferedImage readLogoSafely() {
        try {
            Resource resource = resourceLoader.getResource(FIXED_QR_LOGO_PATH);
            if (!resource.exists()) {
                log.warn("Business QR logo resource not found at {}. Proceeding without center logo.", FIXED_QR_LOGO_PATH);
                return null;
            }
            return ImageIO.read(resource.getInputStream());
        } catch (IOException ex) {
            log.warn("Unable to load Business QR logo from {}. Proceeding without center logo.", FIXED_QR_LOGO_PATH, ex);
            return null;
        }
    }

    private void overlayLogo(BufferedImage qrImage, BufferedImage logo) {
        int size = qrImage.getWidth();
        double boundedRatio = Math.min(Math.max(logoScaleRatio, 0.12), 0.24);
        int logoSize = (int) (size * boundedRatio);
        int x = (size - logoSize) / 2;
        int y = (size - logoSize) / 2;

        Graphics2D graphics = qrImage.createGraphics();
        try {
            graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

            int padding = Math.max(logoSize / 7, 8);
            int padX = x - padding;
            int padY = y - padding;
            int padSize = logoSize + (padding * 2);

            graphics.setColor(Color.WHITE);
            graphics.fillRoundRect(padX, padY, padSize, padSize, padding, padding);

            graphics.setComposite(AlphaComposite.SrcOver);
            graphics.drawImage(logo, x, y, logoSize, logoSize, null);
        } finally {
            graphics.dispose();
        }
    }

    private Color parseHexColor(String raw, Color fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return Color.decode(raw.trim());
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }
}
