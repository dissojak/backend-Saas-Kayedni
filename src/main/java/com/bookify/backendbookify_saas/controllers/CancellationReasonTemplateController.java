package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.models.entities.CancellationReasonTemplate;
import com.bookify.backendbookify_saas.services.CancellationReasonTemplateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Staff-facing CRUD for predefined cancellation/rejection reason templates per business.
 */
@RestController
@RequestMapping("/v1/cancellation-reasons")
@RequiredArgsConstructor
@Tag(name = "Cancellation Reasons", description = "Manage predefined cancellation/rejection reasons per business")
public class CancellationReasonTemplateController {

    private final CancellationReasonTemplateService service;

    /**
     * List all predefined reasons for a business.
     * Returns [{id, reason}] — staff can display these in a dropdown.
     */
    @GetMapping
    @Operation(summary = "List cancellation reason templates for a business")
    public ResponseEntity<?> getReasons(
            @RequestParam Long businessId,
            Authentication authentication
    ) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Authentication required"));
        }
        try {
            List<CancellationReasonTemplate> templates = service.getRawReasons(businessId);
            List<Map<String, Object>> result = templates.stream()
                    .map(t -> Map.<String, Object>of("id", t.getId(), "reason", t.getReason()))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Add a new reason template for a business.
     * Body: { "businessId": 1, "reason": "Client did not confirm" }
     */
    @PostMapping
    @Operation(summary = "Add a cancellation reason template")
    public ResponseEntity<?> addReason(
            @RequestBody Map<String, Object> body,
            Authentication authentication
    ) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Authentication required"));
        }
        try {
            Long businessId = Long.valueOf(body.get("businessId").toString());
            String reason = (String) body.get("reason");
            CancellationReasonTemplate saved = service.addReason(businessId, reason);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("id", saved.getId(), "reason", saved.getReason()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Delete a reason template by ID.
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a cancellation reason template")
    public ResponseEntity<?> deleteReason(
            @PathVariable Long id,
            Authentication authentication
    ) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Authentication required"));
        }
        try {
            service.deleteReason(id);
            return ResponseEntity.ok(Map.of("message", "Reason deleted successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
