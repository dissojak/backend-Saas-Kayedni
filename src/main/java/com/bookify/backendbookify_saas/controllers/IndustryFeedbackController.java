package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackRequest;
import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackResponse;
import com.bookify.backendbookify_saas.models.entities.IndustryFeedbackSubmission;
import com.bookify.backendbookify_saas.services.IndustryFeedbackService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/v1/feedback")
@RequiredArgsConstructor
@Tag(name = "Industry Feedback", description = "Collects 'Other industry' suggestions from signup flow")
public class IndustryFeedbackController {

    private final IndustryFeedbackService industryFeedbackService;

    @PostMapping("/other")
    @Operation(summary = "Submit other-industry feedback", description = "Public endpoint used by generic signup flow")
    public ResponseEntity<IndustryFeedbackResponse> submitOtherIndustryFeedback(
            @Valid @RequestBody IndustryFeedbackRequest request
    ) {
        IndustryFeedbackResponse response = industryFeedbackService.submitFeedback(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/other")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get latest other-industry feedback submissions", description = "Admin-only list for triage")
    public ResponseEntity<List<IndustryFeedbackSubmission>> getLatestOtherIndustryFeedback() {
        return ResponseEntity.ok(industryFeedbackService.getLatestFeedback());
    }
}
