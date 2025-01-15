SELECT * FROM public."User"
WHERE email LIKE 'albin@%.se'


BEGIN TRANSACTION;

WITH vars AS (
    SELECT 'albin@%.se' AS email_pattern
),
-- 1) Mark the user as deleted
update_user AS (
    UPDATE "User" u
    SET deleted = TRUE
    FROM vars
    WHERE u.email ILIKE vars.email_pattern
      AND u.deleted = FALSE
    RETURNING id
),
-- 2) Mark UserOrganization as deleted
update_user_org AS (
    UPDATE "UserOrganization" uo
    SET deleted = TRUE
    FROM vars
    WHERE uo.user_id IN (
        SELECT id FROM update_user
    )
      AND uo.deleted = FALSE
    RETURNING id
),
-- 3) Mark UserOrganizationRole as deleted
update_user_org_role AS (
    UPDATE "UserOrganizationRole" uor
    SET deleted = TRUE
    WHERE uor.user_organization_id IN (
        SELECT id FROM update_user_org
    )
      AND uor.deleted = FALSE
    RETURNING id
),
-- 4) Mark UserOrganizationRoleNotification as deleted
update_user_org_role_notif AS (
    UPDATE "UserOrganizationRoleNotification" uorn
    SET deleted = TRUE
    WHERE uorn.user_organization_role_id IN (
        SELECT id FROM update_user_org_role
    )
      AND uorn.deleted = FALSE
    RETURNING id
)
-- 5) Finally, show results
SELECT DISTINCT
    u.email,
    u.name,
    u.deleted       AS user_deleted,
    uo.deleted      AS user_org_deleted,
    uor.deleted     AS user_org_role_deleted,
    uorn.deleted    AS user_org_role_notification_deleted
FROM "User" u
LEFT JOIN "UserOrganization" uo
       ON u.id = uo.user_id
LEFT JOIN "UserOrganizationRole" uor
       ON uo.id = uor.user_organization_id
LEFT JOIN "UserOrganizationRoleNotification" uorn
       ON uor.id = uorn.user_organization_role_id
WHERE u.email ILIKE (SELECT email_pattern FROM vars);

COMMIT;
