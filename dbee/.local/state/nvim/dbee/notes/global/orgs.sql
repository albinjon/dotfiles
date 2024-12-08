SELECT * FROM public."User"
WHERE email LIKE 'albin@%.se'


BEGIN;
-- Update User table
UPDATE "User" u
SET deleted = true
WHERE u.email = email AND u.deleted = false;
-- Update UserOrganization table
UPDATE "UserOrganization" uo
SET deleted = true
WHERE uo.user_id = (SELECT id FROM "User" WHERE email = email)
  AND uo.deleted = false;
-- Update UserOrganizationRole table
UPDATE "UserOrganizationRole" uor
SET deleted = true
WHERE uor.user_organization_id IN (
    SELECT uo.id 
    FROM "UserOrganization" uo
    JOIN "User" u ON u.id = uo.user_id
    WHERE u.email = email
)
AND uor.deleted = false;
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
    u.email = email;
COMMIT; 
