<#macro emailLayout>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin:0;padding:0;background:#edf4fa;font-family:'Atkinson Hyperlegible',Arial,Helvetica,sans-serif;color:#58585a;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#edf4fa;padding:24px 0;">
    <tr>
      <td align="center">
        <table role="presentation" width="560" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 4px 14px rgba(37,83,123,0.1);">
          <tr>
            <td align="center" style="background:#ffffff;padding:22px 28px 18px;border-bottom:4px solid #ffd700;">
              <img src="https://galaxyproject.org/images/GalaxyNewLogo_GalaxyProject_Trans.png" alt="Galaxy" height="40" style="height:40px;display:inline-block;border:0;">
            </td>
          </tr>
          <tr>
            <td style="padding:28px;font-size:15px;line-height:1.6;color:#2c3143;">
              <#nested>
            </td>
          </tr>
          <tr>
            <td style="padding:16px 28px;background:#edf4fa;font-size:12px;color:#58585a;">
              You are receiving this email from the Galaxy authentication service.
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
</#macro>
