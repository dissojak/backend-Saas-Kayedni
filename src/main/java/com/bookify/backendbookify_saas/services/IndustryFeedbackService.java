package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackRequest;
import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackResponse;
import com.bookify.backendbookify_saas.models.entities.IndustryFeedbackSubmission;

import java.util.List;

public interface IndustryFeedbackService {
    IndustryFeedbackResponse submitFeedback(IndustryFeedbackRequest request);
    List<IndustryFeedbackSubmission> getLatestFeedback();
}
