package com.bookify.backendbookify_saas.models.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SignupOtherIndustryFeedbackRequest {

    @NotBlank(message = "Industry name is required")
    @Size(max = 150, message = "Industry name must not exceed 150 characters")
    private String industryName;

    @NotBlank(message = "Description is required")
    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;

    @NotBlank(message = "Phone number is required")
    @Size(max = 30, message = "Phone number must not exceed 30 characters")
    private String phoneNumber;

    @Size(max = 60, message = "Source slug must not exceed 60 characters")
    private String sourceSlug;

    @Size(max = 150, message = "Source category name must not exceed 150 characters")
    private String sourceCategoryName;

    @Email(message = "Contact email must be valid")
    @Size(max = 320, message = "Contact email must not exceed 320 characters")
    private String contactEmail;
}
