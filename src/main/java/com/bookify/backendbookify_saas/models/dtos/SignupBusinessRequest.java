package com.bookify.backendbookify_saas.models.dtos;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SignupBusinessRequest {

    @NotBlank(message = "Business name is required")
    @Size(min = 2, max = 150, message = "Business name must be between 2 and 150 characters")
    private String name;

    @NotBlank(message = "Business location is required")
    @Size(min = 2, max = 200, message = "Business location must be between 2 and 200 characters")
    private String location;

    @Size(min = 8, max = 20, message = "Business phone must be between 8 and 20 characters")
    private String phone;

    @Email(message = "Business email must be valid")
    private String email;

    @NotNull(message = "Business category is required")
    private Long categoryId;

    @Size(max = 2000, message = "Business description must be at most 2000 characters")
    private String description;

    @Valid
    private SignupOtherIndustryFeedbackRequest otherIndustryFeedback;
}