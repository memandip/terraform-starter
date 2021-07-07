# Configure Kubernetes authentication

> The initial [root token](https://www.vaultproject.io/docs/concepts/tokens.html#root-tokens) is a privileged user that can perform any operation at any path. The web application only requires the ability to read secrets defined at a single path. The application should authenticate and be granted a token with limited access.

> **Best Practice:** It is recommended that [root tokens](https://www.vaultproject.io/docs/concepts/tokens.html#root-tokens) are only used for initial setup of an authentication method and policies. Afterwards they should be revoked.

> Vault provides a [kubernetes authentication](https://www.vaultproject.io/docs/auth/kubernetes.html) method that enables clients to authenticate with a Kubernetes Service Account Token.

1. Select the **Access** tab in the Vault UI.
   - The view displays all the authentication methods that are enabled.
2. Under **Authtication Methods**, select **Enable new method**.
3. Under **Enable an Authentication Method**, select **Kubernetes** and **Next**.
   - The view displays the method options configuration for the authentication method.
4. Select **Enable Method** to create this authentication method with the default method options configuration.
   - The view displays the configuration settings that enable the auth method to communicate with the Kubernetes cluster. The Kubernetes host, CA Certificate, and Token Reviewer JWT require configuration. These values are defined on the `vault-0` pod.
5. Enter the address returned from the following command in **Kubernetes host** field. 
   - ```
      echo "https://$( kubectl exec vault-0 -- env | grep KUBERNETES_PORT_443_TCP_ADDR| cut -f2 -d'='):443"
      ```
   - The command displays the environment variables defined on the node, fileters to only the `KUBERNETES_PORT_443_TCP_ADDR` address and then prefixes the `https://` protocol and appends the `443` port.
6. For the **Kubernetes CA Certificate** field, toggle the **Enter as text**. 
7. Enter the certificate returned from the following command in **Kubernetes CA Certificate** entered as text.
   - ```
      kubectl exec vault-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      ```
8. Expand the **Kubernetes Options** section.
9. Enter the token returned from the following command in **Token Reviewer JWT** field.
   - ```
      echo $(kubectl exec vault-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
      ```  
   - The command displays the JSON Web Token (JWT) mounted by Kubernetes on the `vault-0` pod.
10. Select **Save**. 

> The Kubernetes authentication method is configured to work within the cluster. The web application requires a Vault policy to read the secret and a Kubernetes rolw to grant it that policy.