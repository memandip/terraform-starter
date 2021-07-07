# Configure web application authentication

> For a client of the Vault server to read the secret data defined in the [Set a secret in Vault](./02-setting-secrets.md) step requires that the read capaility be granted for the path `secret/data/devwebapp/config`.

1. Select the **Policies** tab in the Vault UI.
2. Under **ACL Policies**, select the **Create ACL policy** action.
3. Enter `devwebapp` in the **Name** field.
4. Enter this policy in the **Policy** field.
   - ```hcl
     # Read the configuration secret
     path "secret/data/devwebapp/config" {
       capabilities = ["read"]
     } 
     ```
5. Select **Create policy**.
   - This policy is created and the view displays its name and contents.
   - The policy is assigned to the web application through a Kubernetes role. This role also defines the Kubernetes service account and Kubernetes namespace that is allowed to authenticate.
6. Select the **Access** tab in the Vault UI.
7. Under **Authentication Methods**, click the ... for the **kubernetes /** auth method. Select **View configuration**.
8. Under the **kubernetes** method, choose the **Roles** tab.
   - This view displays all the roles defined for this authentication method.
9. Select **Create role**.
10. Enter `devweb-app` in the **Name** field.
11. Enter `internal-app` in the **Bound service account names** field.
    - > This field contains one or more Kubernetes service accounts that this role supports. This Kubernetes service account is created in the Deploy web application step.  
12. Enter `default` in the **Bound service account namespaces** field and select **Add**.
    - This field contains one or more Kubernetes namespaces that this role supports.
13. Expand the **Tokens** section.
14. Enter `devwebapp` in the **Generated Token's Policies**.
15. Select **Save**.

The role is created and the view displays its name in the roles view for this authentication method.