package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.Business;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.models.enums.AvailabilityStatus;
import com.bookify.backendbookify_saas.models.enums.BusinessStatus;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


/**
 * Repository pour l'entité Business
 * Relation 1:1 - Un propriétaire a un seul business
 */
@Repository
public interface BusinessRepository extends JpaRepository<Business, Long> {

    /**
     * Trouve le business associé à un propriétaire
     * @param owner Le propriétaire du business
     * @return Optional contenant le business ou vide si non trouvé
     */
    Optional<Business> findByOwner(User owner);

    /**
     * Trouve un business par son nom
     * @param name Le nom du business
     * @return Optional contenant le business ou vide si non trouvé
     */
    Optional<Business> findByName(String name);

    /**
     * Vérifie si un propriétaire a déjà un business
     * @param owner Le propriétaire
     * @return true si le propriétaire a déjà un business, false sinon
     */
    boolean existsByOwner(User owner);

    /**
     * Trouve le business associé à un propriétaire
     * @param ownerId Le propriétaire du business
     * @return Optional contenant le business ou vide si non trouvé
     */
    Optional<Business> findByOwnerId(Long ownerId);

    /**
     * Find all businesses with the given status
     */
    List<Business> findByStatus(BusinessStatus status);

    /**
     * Find paged businesses with the given status
     */
    Page<Business> findByStatus(BusinessStatus status, Pageable pageable);

    /**
     * New: case-insensitive partial search by name, filtering by status
     */
    List<Business> findByNameContainingIgnoreCaseAndStatus(String name, BusinessStatus status);

    /**
     * Search by location (case-insensitive partial match) and status
     */
    List<Business> findByLocationContainingIgnoreCaseAndStatus(String location, BusinessStatus status);

    /**
     * Search by category and status
     */
    List<Business> findByCategoryIdAndStatus(Long categoryId, BusinessStatus status);

    /**
     * Search by name OR description (case-insensitive partial match) and status
     */
    @org.springframework.data.jpa.repository.Query("SELECT b FROM Business b WHERE b.status = :status AND (LOWER(b.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(b.description) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<Business> searchByQueryAndStatus(@org.springframework.data.repository.query.Param("query") String query, @org.springframework.data.repository.query.Param("status") BusinessStatus status);

    /**
     * Advanced search: query (name/description) + optional location + status
     */
    @org.springframework.data.jpa.repository.Query("SELECT b FROM Business b WHERE b.status = :status AND (LOWER(b.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(b.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND (:location IS NULL OR LOWER(b.location) LIKE LOWER(CONCAT('%', :location, '%')))")
    List<Business> advancedSearch(@org.springframework.data.repository.query.Param("query") String query, @org.springframework.data.repository.query.Param("location") String location, @org.springframework.data.repository.query.Param("status") BusinessStatus status);

    /**
     * Advanced search with category filter
     */
    @org.springframework.data.jpa.repository.Query("SELECT b FROM Business b WHERE b.status = :status AND (:query IS NULL OR LOWER(b.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(b.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND (:location IS NULL OR LOWER(b.location) LIKE LOWER(CONCAT('%', :location, '%'))) AND (:categoryId IS NULL OR b.category.id = :categoryId) AND (:dayOfWeek IS NULL OR b.weekendDay IS NULL OR b.weekendDay <> :dayOfWeek) AND (:selectedDate IS NULL OR EXISTS (SELECT sa.id FROM StaffAvailability sa WHERE sa.staff.employerBusiness.id = b.id AND sa.date = :selectedDate AND sa.status IN :workingStatuses) OR NOT EXISTS (SELECT sa2.id FROM StaffAvailability sa2 WHERE sa2.staff.employerBusiness.id = b.id AND sa2.date = :selectedDate))")
    List<Business> fullSearch(@org.springframework.data.repository.query.Param("query") String query, @org.springframework.data.repository.query.Param("location") String location, @org.springframework.data.repository.query.Param("categoryId") Long categoryId, @org.springframework.data.repository.query.Param("dayOfWeek") DayOfWeek dayOfWeek, @org.springframework.data.repository.query.Param("selectedDate") LocalDate selectedDate, @org.springframework.data.repository.query.Param("workingStatuses") Collection<AvailabilityStatus> workingStatuses, @org.springframework.data.repository.query.Param("status") BusinessStatus status);

    @org.springframework.data.jpa.repository.Query("SELECT b FROM Business b WHERE b.status = :status AND (:query IS NULL OR LOWER(b.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(b.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND (:location IS NULL OR LOWER(b.location) LIKE LOWER(CONCAT('%', :location, '%'))) AND (:categoryId IS NULL OR b.category.id = :categoryId) AND (:dayOfWeek IS NULL OR b.weekendDay IS NULL OR b.weekendDay <> :dayOfWeek) AND (:selectedDate IS NULL OR EXISTS (SELECT sa.id FROM StaffAvailability sa WHERE sa.staff.employerBusiness.id = b.id AND sa.date = :selectedDate AND sa.status IN :workingStatuses) OR NOT EXISTS (SELECT sa2.id FROM StaffAvailability sa2 WHERE sa2.staff.employerBusiness.id = b.id AND sa2.date = :selectedDate))")
    Page<Business> fullSearchPaged(@org.springframework.data.repository.query.Param("query") String query, @org.springframework.data.repository.query.Param("location") String location, @org.springframework.data.repository.query.Param("categoryId") Long categoryId, @org.springframework.data.repository.query.Param("dayOfWeek") DayOfWeek dayOfWeek, @org.springframework.data.repository.query.Param("selectedDate") LocalDate selectedDate, @org.springframework.data.repository.query.Param("workingStatuses") Collection<AvailabilityStatus> workingStatuses, @org.springframework.data.repository.query.Param("status") BusinessStatus status, Pageable pageable);
}
