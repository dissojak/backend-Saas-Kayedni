package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.entities.Business;
import com.bookify.backendbookify_saas.models.entities.CancellationReasonTemplate;
import com.bookify.backendbookify_saas.repositories.BusinessRepository;
import com.bookify.backendbookify_saas.repositories.CancellationReasonTemplateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CancellationReasonTemplateService {

    private final CancellationReasonTemplateRepository repository;
    private final BusinessRepository businessRepository;

    @Transactional(readOnly = true)
    public List<String> getReasons(Long businessId) {
        return repository.findAllByBusiness_IdOrderByCreatedAtAsc(businessId)
                .stream()
                .map(t -> t.getId() + "|" + t.getReason())
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<CancellationReasonTemplate> getRawReasons(Long businessId) {
        return repository.findAllByBusiness_IdOrderByCreatedAtAsc(businessId);
    }

    @Transactional
    public CancellationReasonTemplate addReason(Long businessId, String reason) {
        if (reason == null || reason.isBlank()) {
            throw new IllegalArgumentException("Reason must not be blank");
        }
        Business business = businessRepository.findById(businessId)
                .orElseThrow(() -> new RuntimeException("Business not found"));

        CancellationReasonTemplate template = CancellationReasonTemplate.builder()
                .business(business)
                .reason(reason.trim())
                .build();
        return repository.save(template);
    }

    @Transactional
    public void deleteReason(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Reason template not found");
        }
        repository.deleteById(id);
    }
}
