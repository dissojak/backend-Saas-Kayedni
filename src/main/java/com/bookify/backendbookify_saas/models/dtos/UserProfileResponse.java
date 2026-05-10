package com.bookify.backendbookify_saas.models.dtos;

import com.bookify.backendbookify_saas.models.enums.RoleEnum;
import com.bookify.backendbookify_saas.models.enums.UserStatusEnum;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for current user profile response (/me endpoint)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserProfileResponse {

    /**
     * Constructor used by the JPQL constructor expression in StaffRepository.
     * Maps staff fields without 2FA information (twoFactorEnabled/twoFactorMethods remain null).
     * Parameter order must exactly match the query in StaffRepository.findUserProfileResponsesByBusinessId.
     */
    public UserProfileResponse(
        Long userId,
        String name,
        String email,
        String phoneNumber,
        RoleEnum role,
        UserStatusEnum status,
        String avatarUrl,
        Boolean hasBusiness,
        Long businessId,
        String businessName,
        String businessCategoryName,
        java.time.LocalTime defaultStartTime,
        java.time.LocalTime defaultEndTime
    ) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.status = status;
        this.avatarUrl = avatarUrl;
        this.hasBusiness = hasBusiness;
        this.businessId = businessId;
        this.businessName = businessName;
        this.businessCategoryName = businessCategoryName;
        this.defaultStartTime = defaultStartTime;
        this.defaultEndTime = defaultEndTime;
    }

    private Long userId;
    private String name;
    private String email;
    private String phoneNumber;
    private RoleEnum role;
    private UserStatusEnum status;
    private String avatarUrl;
    private Boolean twoFactorEnabled;
    private List<String> twoFactorMethods;

    // For business owners
    private Boolean hasBusiness;
    private Long businessId;
    private String businessName;
    private String businessCategoryName;

    // For staff: default working times
    private java.time.LocalTime defaultStartTime;
    private java.time.LocalTime defaultEndTime;
}
