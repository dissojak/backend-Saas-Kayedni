package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.Category;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    boolean existsByName(String name);

    List<Category> findByIdNot(Long excludedId);

    Page<Category> findByIdNot(Long excludedId, Pageable pageable);

    List<Category> findByIdNotAndNameContainingIgnoreCaseOrderByNameAsc(Long excludedId, String query, Pageable pageable);

    List<Category> findByNameContainingIgnoreCaseOrderByNameAsc(String query, Pageable pageable);
}
