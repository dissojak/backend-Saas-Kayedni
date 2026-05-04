-- Flyway migration: create business_invite_tokens table
CREATE TABLE IF NOT EXISTS business_invite_tokens (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  raw_token VARCHAR(8),
  token_hash VARCHAR(64) NOT NULL UNIQUE,
  created_by_admin_id BIGINT,
  assigned_email VARCHAR(255),
  expires_at TIMESTAMP NULL,
  used_at TIMESTAMP NULL,
  used_by_user_id BIGINT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_invite_created_by_admin FOREIGN KEY (created_by_admin_id) REFERENCES users(id),
  CONSTRAINT fk_invite_used_by_user FOREIGN KEY (used_by_user_id) REFERENCES users(id)
);

CREATE INDEX idx_invite_token_hash ON business_invite_tokens(token_hash);
CREATE INDEX idx_invite_status ON business_invite_tokens(status);
CREATE INDEX idx_invite_assigned_email ON business_invite_tokens(assigned_email);
CREATE INDEX idx_invite_expires_at ON business_invite_tokens(expires_at);
