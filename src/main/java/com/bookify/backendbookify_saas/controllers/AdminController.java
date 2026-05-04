package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.models.dtos.InviteKeyAdminDto;
import com.bookify.backendbookify_saas.models.dtos.ValidateInviteKeyResponse;
import com.bookify.backendbookify_saas.models.entities.BusinessInviteToken;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import com.bookify.backendbookify_saas.services.BusinessInviteTokenService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/v1/admin/invite-keys")
@RequiredArgsConstructor
@Tag(name = "Admin - Invite Keys", description = "Admin operations for invite keys")
public class AdminController {

    private final BusinessInviteTokenService inviteService;

    @PostMapping("/generate")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Generate bulk invite keys", description = "Generate a batch of one-time invite keys")
    public ResponseEntity<List<String>> generateKeys(@RequestParam(defaultValue = "100") int count) {
        List<String> keys = inviteService.generateBulkKeys(count);
        return ResponseEntity.ok(keys);
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "List invite keys", description = "List invite keys with status and metadata (raw tokens not returned)")
    public ResponseEntity<List<InviteKeyAdminDto>> listKeys(@RequestParam(required = false) InviteTokenStatus status) {
        List<BusinessInviteToken> tokens = inviteService.listKeys(status);
        List<InviteKeyAdminDto> dtos = tokens.stream().map(t -> InviteKeyAdminDto.builder()
                .id(t.getId())
                .status(t.getStatus())
                .createdAt(t.getCreatedAt())
                .expiresAt(t.getExpiresAt())
                .usedAt(t.getUsedAt())
                .usedByUserId(t.getUsedByUser() != null ? t.getUsedByUser().getId() : null)
                .assignedEmail(t.getAssignedEmail())
                .build()).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @PostMapping("/{id}/revoke")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Revoke an invite key", description = "Mark a key as revoked so it cannot be used")
    public ResponseEntity<Void> revokeKey(@PathVariable Long id) {
        inviteService.revokeKey(id);
        return ResponseEntity.noContent().build();
    }

}
