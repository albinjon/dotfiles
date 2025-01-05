SELECT * FROM public."User"
WHERE email LIKE 'albin@%.se'


BEGIN TRANSACTION;

WITH vars AS (
    SELECT 'albin@%.se' AS email_pattern
)

UPDATE "User" u
SET deleted = true
WHERE u.email = ( SELECT emailQuery FROM constants ) AND u.deleted = false;

UPDATE "UserOrganization" uo
SET deleted = true
WHERE uo.user_id = (SELECT id FROM "User" WHERE email = ( SELECT emailQuery FROM constants ) )
  AND uo.deleted = false;

UPDATE "UserOrganizationRole" uor
SET deleted = true
WHERE uor.user_organization_id IN (
    SELECT uo.id 
    FROM "UserOrganization" uo
    JOIN "User" u ON u.id = uo.user_id
    WHERE u.email = ( SELECT emailQuery FROM constants )
)
AND uor.deleted = false;

UPDATE "UserOrganizationRoleNotification" uorn
SET deleted = true
WHERE uorn.user_organization_role_id IN (
    SELECT uor.id
    FROM "UserOrganizationRole" uor
    JOIN "UserOrganization" uo ON uor.user_organization_id = uo.id
    JOIN "User" u ON uo.user_id = u.id
    WHERE u.email = ( SELECT emailQuery FROM constants )
)
AND uorn.deleted = false;

SELECT DISTINCT
    u.email,
    u.name,
    u.deleted,
    uo.deleted,
    uor.deleted,
    uorn.deleted
FROM 
    "User" u
LEFT JOIN 
    "UserOrganization" uo ON u.id = uo.user_id
LEFT JOIN 
    "UserOrganizationRole" uor ON uo.id = uor.user_organization_id
LEFT JOIN 
    "UserOrganizationRoleNotification" uorn ON uor.id = uorn.user_organization_role_id
WHERE 
    u.email = ( SELECT emailQuery FROM constants );

COMMIT;
