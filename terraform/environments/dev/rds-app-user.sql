-- Run as the RDS master user after the database schema has been created.
-- Set the role password interactively in psql with:
--   \password gitops_platform_app
-- Do not put the password in this file or in shell history.

CREATE ROLE gitops_platform_app LOGIN;

GRANT CONNECT ON DATABASE gitops_platform_database TO gitops_platform_app;
GRANT USAGE ON SCHEMA public TO gitops_platform_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO gitops_platform_app;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO gitops_platform_app;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gitops_platform_app;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO gitops_platform_app;
