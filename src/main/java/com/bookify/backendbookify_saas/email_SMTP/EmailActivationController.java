package com.bookify.backendbookify_saas.email_SMTP;

import com.bookify.backendbookify_saas.services.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Endpoints for user signup and login")
public class EmailActivationController {

    private final AuthService authService;

    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    @Value("${frontend.prod.url:http://54.38.183.201/frontend}")
    private String prodFrontendUrl;

    @GetMapping("/activate")
    @Operation(summary = "Activate a user account", description = "Activates the account using the token received by email")
    public ResponseEntity<Map<String, Object>> activateAccount(@RequestParam("token") String token) {
        String message = authService.activateAccount(token);
        boolean success = message.toLowerCase().contains("successfully");

        return ResponseEntity.status(success ? HttpStatus.OK : HttpStatus.BAD_REQUEST)
                .body(Map.of(
                        "success", success,
                        "message", message
                ));
    }
}
