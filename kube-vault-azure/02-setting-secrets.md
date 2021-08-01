# Set a secret in Vault

> The we application that you deploy in the [Deploy web application](./Readme.md#) step, expects Vault to store a username and password at the path `secret/webapp/config`. To create this secret requires you to enable the [key-value secret engine](https://www.vaultproject.io/docs/secrets/kv/kv-v2.html), and store a secret username and password at that defined path.

1. Select the **Secrets** tab in the Vault UI. 
2. Under **Secrets Engines**, select **Enable new engine**.
3. Under **Enable a Secrets Engine**, select **KV** and **Next**.
4. Enter `secret` in the **Path** text field.
5. Select **Enable Engine**.
  - The view changes to display all the secrets for this secrets engine.
6. Select the **Create secret** action. 
7. Enter `devwebapp/config` in the **Path for this secret**.
8. Under **Version data**, enter `username` in the **key** field and `giraffe` in the **value** field.
9. Select **Add** to create another key and value field in **Version data**.
10. Enter `password` in the **key** field and `salsa` in the **value** field.
11. Select **Save** to create the secret.
    1.  The view displays the contents of the newly created secret.

You successfully created the secret for the web application.