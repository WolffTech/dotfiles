# Synthetic change request example

This example contains fictional systems and identifiers. Use it only to match structure and information density. Use the current conversation and supplied materials as the source of facts.

## Short description

Renew the TLS certificate for the customer portal

## Description

Replace the expiring TLS certificate for `portal.example.test` on the reverse proxies that serve production traffic.

Certificate configuration:

1. Certificate name: `portal-example-test-2027`
2. Endpoints: `proxy-edge-01` and `proxy-edge-02`
3. Secret location: `certificates/portal-production`
4. Supported protocols: TLS 1.2 and TLS 1.3

Keep the current certificate available for backout until the renewed certificate passes validation.

## Justification

Renewing the certificate prevents an interruption when the current certificate expires. Storing the private key in the approved secret store preserves the existing access controls.

## Implementation plan

1. Confirm the renewed certificate, private key, intermediate chain, and expiration date are correct.
2. Record the current certificate bindings and export the active proxy configuration.
3. Import `portal-example-test-2027` into `certificates/portal-production`.
4. Update `proxy-edge-02`:

   - Remove the proxy from traffic rotation.
   - Bind the renewed certificate to `portal.example.test`.
   - Reload the proxy configuration.
5. Validate the certificate chain and portal response through `proxy-edge-02`.
6. Return `proxy-edge-02` to service and repeat the update on `proxy-edge-01`.
7. Confirm both proxies are serving the renewed certificate.
8. Monitor proxy errors and portal availability after the change.

## Risk and impact analysis

1. An incomplete certificate chain may cause browser or client trust errors.

   - Likelihood: Low
   - Mitigation: Validate the certificate and intermediate chain before changing a binding.
2. Reloading a proxy with an invalid configuration may interrupt traffic through that proxy.

   - Likelihood: Low
   - Mitigation: Update one proxy at a time and validate it before returning it to service.
3. Incorrect private key permissions may prevent the proxies from loading the renewed certificate.

   - Likelihood: Low
   - Mitigation: Confirm secret-store access before updating either proxy.
4. No application or data impact is expected because the change updates the TLS binding only.

## Backout plan

1. Remove the affected proxy from traffic rotation.
2. Restore the previous certificate binding and reload the proxy configuration.
3. Validate the previous certificate and return the proxy to service.
4. Repeat the backout on the other proxy if it was updated.
5. Remove the renewed certificate from the secret store if it is no longer required.

## Communication plan

1. Email stakeholders when implementation begins.
2. Email stakeholders when implementation finishes, including the validation results or any backout actions.

## Post test plan

1. Confirm `portal.example.test` presents the renewed certificate and complete trust chain.
2. Confirm the certificate expiration date and supported TLS protocols are correct.
3. Confirm both proxies are healthy and serving production traffic.
4. Confirm the portal loads successfully from an external client.
5. Confirm proxy error rates remain within their normal range.
