package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.models.dtos.CategoryCreateRequest;
import com.bookify.backendbookify_saas.models.entities.Category;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.repositories.CategoryRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.bookify.backendbookify_saas.services.CategoryService;
import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private static final Long EXCLUDED_SIGNUP_CATEGORY_ID = 10L; // ID of the "Other industry" category to exclude from general listings

    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    @Override
    public List<Category> findAll() {
        return categoryRepository.findByIdNot(EXCLUDED_SIGNUP_CATEGORY_ID);
    }

    @Override
    public List<Category> findPreview(int limit) {
        if (limit <= 0) {
            limit = 12;
        }
        return categoryRepository.findByIdNot(EXCLUDED_SIGNUP_CATEGORY_ID, PageRequest.of(0, limit)).getContent();
    }

    @Override
    public List<Category> search(String query, int limit) {
        int safeLimit = (limit > 0 && limit <= 50) ? limit : 12;
        String cleanQuery = query != null ? query.trim() : "";
        if (cleanQuery.isEmpty()) {
            return categoryRepository.findByIdNot(EXCLUDED_SIGNUP_CATEGORY_ID, PageRequest.of(0, safeLimit)).getContent();
        }
        return categoryRepository.findByIdNotAndNameContainingIgnoreCaseOrderByNameAsc(
                EXCLUDED_SIGNUP_CATEGORY_ID,
                cleanQuery,
                PageRequest.of(0, safeLimit)
        );
    }

    @Override
    @Transactional
    public Category createCategory(CategoryCreateRequest request, String creatorUserId) {
        if (request == null || request.getName() == null || request.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name is required");
        }

        String name = request.getName().trim();
        if (categoryRepository.existsByName(name)) {
            throw new IllegalArgumentException("Category with the same name already exists");
        }

        Long userId = Long.parseLong(creatorUserId);
        User creator = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Creator user not found"));

        Category category = new Category();
        category.setName(name);
        category.setDescription(request.getDescription());
        category.setIcon(request.getIcon());
        category.setCreatedBy(creator);

        return categoryRepository.save(category);
    }
}
