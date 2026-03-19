package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.models.dtos.BusinessImageResponse;
import com.bookify.backendbookify_saas.models.dtos.BusinessResponse;
import com.bookify.backendbookify_saas.models.dtos.BusinessSearchDto;
import com.bookify.backendbookify_saas.models.entities.Business;
import com.bookify.backendbookify_saas.models.entities.BusinessImage;
import com.bookify.backendbookify_saas.repositories.BusinessImageRepository;
import com.bookify.backendbookify_saas.repositories.BusinessRepository;
import com.bookify.backendbookify_saas.services.BusinessImageService;
import com.bookify.backendbookify_saas.services.BusinessService;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


/**
 * Public endpoints to list businesses. Returns DTOs to avoid JPA proxy serialization issues.
 */
@RestController
@RequestMapping("/v1/businesses")
@RequiredArgsConstructor
public class BusinessPublicController {

    private final BusinessRepository businessRepository;
    private final BusinessService businessService;
    private final BusinessImageService businessImageService;
    private final BusinessImageRepository businessImageRepository;

    @GetMapping
    public ResponseEntity<List<BusinessResponse>> listAll() {
        List<Business> list = businessRepository.findByStatus(com.bookify.backendbookify_saas.models.enums.BusinessStatus.ACTIVE);
        List<BusinessResponse> dto = list.stream().map(this::map).collect(Collectors.toList());
        return ResponseEntity.ok(dto);
    }

    @GetMapping("/paged")
    public ResponseEntity<PagedBusinessResponse> listAllPaged(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.max(1, Math.min(size, 100));

        Page<Business> businessPage = businessRepository.findByStatus(
                com.bookify.backendbookify_saas.models.enums.BusinessStatus.ACTIVE,
                PageRequest.of(safePage, safeSize)
        );

        List<BusinessResponse> content = businessPage.getContent().stream().map(this::map).toList();

        return ResponseEntity.ok(new PagedBusinessResponse(
                content,
                businessPage.getNumber(),
                businessPage.getSize(),
                businessPage.getTotalElements(),
                businessPage.getTotalPages(),
                businessPage.hasNext(),
                businessPage.hasPrevious()
        ));
    }

    @GetMapping("/search")
    public ResponseEntity<List<BusinessSearchDto>> searchByName(@RequestParam(name = "name") String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Query parameter 'name' is required");
        }
        List<BusinessSearchDto> results = businessService.searchByName(name.trim());
        if (results == null) results = List.of();
        return ResponseEntity.ok(results);
    }

    /**
     * Advanced search endpoint with optional query, location, and category filters
     * GET /v1/businesses/search/advanced?q=service&location=city&categoryId=1&date=2026-03-19
     */
    @GetMapping("/search/advanced")
    public ResponseEntity<List<BusinessSearchDto>> advancedSearch(
            @RequestParam(name = "q", required = false) String query,
            @RequestParam(name = "location", required = false) String location,
            @RequestParam(name = "categoryId", required = false) Long categoryId,
            @RequestParam(name = "date", required = false) String date) {
        
        // At least one parameter must be provided
        if ((query == null || query.isBlank()) && (location == null || location.isBlank()) && categoryId == null && (date == null || date.isBlank())) {
            return ResponseEntity.ok(List.of());
        }

        LocalDate selectedDate = null;
        if (date != null && !date.isBlank()) {
            selectedDate = LocalDate.parse(date);
        }
        
        List<BusinessSearchDto> results = businessService.advancedSearch(query, location, categoryId, selectedDate);
        if (results == null) results = List.of();
        return ResponseEntity.ok(results);
    }

    @GetMapping("/search/advanced/paged")
    public ResponseEntity<PagedBusinessSearchResponse> advancedSearchPaged(
            @RequestParam(name = "q", required = false) String query,
            @RequestParam(name = "location", required = false) String location,
            @RequestParam(name = "categoryId", required = false) Long categoryId,
            @RequestParam(name = "date", required = false) String date,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "12") int size) {

        LocalDate selectedDate = null;
        if (date != null && !date.isBlank()) {
            selectedDate = LocalDate.parse(date);
        }

        var paged = businessService.advancedSearchPaged(query, location, categoryId, selectedDate, page, size);
        return ResponseEntity.ok(new PagedBusinessSearchResponse(
                paged.getContent(),
                paged.getNumber(),
                paged.getSize(),
                paged.getTotalElements(),
                paged.getTotalPages(),
                paged.hasNext(),
                paged.hasPrevious()
        ));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BusinessResponse> getById(@PathVariable Long id) {
        return businessRepository.findById(id)
                .map(b -> ResponseEntity.ok(map(b)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Public endpoint to get business images
     * GET /v1/businesses/{businessId}/images
     */
    @GetMapping("/{businessId}/images")
    public ResponseEntity<List<BusinessImageResponse>> getBusinessImages(@PathVariable Long businessId) {
        // Verify business exists
        if (!businessRepository.existsById(businessId)) {
            return ResponseEntity.notFound().build();
        }
        List<BusinessImageResponse> images = businessImageService.getBusinessImages(businessId);
        return ResponseEntity.ok(images);
    }

    private BusinessResponse map(Business b) {
        // Get average rating from BusinessRating (same as search results)
        Double avgRating = null;
        Long ratingCount = 0L;
        try {
            if (b.getRatings() != null && !b.getRatings().isEmpty()) {
                avgRating = b.getRatings().stream()
                        .mapToInt(r -> r.getScore())
                        .average()
                        .orElse(Double.NaN);
                if (Double.isNaN(avgRating)) avgRating = null;
                ratingCount = (long) b.getRatings().size();
            }
        } catch (Exception ignored) {}

        // Get first image URL
        String firstImageUrl = getFirstImageUrl(b.getId());

        BusinessResponse.BusinessResponseBuilder builder = BusinessResponse.builder()
                .id(b.getId())
                .name(b.getName())
                .location(b.getLocation())
                .phone(b.getPhone())
                .email(b.getEmail())
                .status(b.getStatus())
                .description(b.getDescription())
                .rating(avgRating)
                .reviewCount(ratingCount)
                .firstImageUrl(firstImageUrl);

        if (b.getCategory() != null) {
            builder.categoryId(b.getCategory().getId())
                    .categoryName(b.getCategory().getName());
        }
        if (b.getOwner() != null) {
            builder.ownerId(b.getOwner().getId());
        }
        // include weekendDay if present
        builder.weekendDay(b.getWeekendDay());

        return builder.build();
    }

    private String getFirstImageUrl(Long businessId) {
        List<BusinessImage> images = businessImageRepository.findByBusinessIdOrderByDisplayOrderAsc(businessId);
        return images.isEmpty() ? null : images.get(0).getImageUrl();
    }

    public record PagedBusinessResponse(
            List<BusinessResponse> content,
            int page,
            int size,
            long totalElements,
            int totalPages,
            boolean hasNext,
            boolean hasPrevious
    ) {}

        public record PagedBusinessSearchResponse(
            List<BusinessSearchDto> content,
            int page,
            int size,
            long totalElements,
            int totalPages,
            boolean hasNext,
            boolean hasPrevious
        ) {}
}
