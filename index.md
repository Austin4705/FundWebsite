---
layout: page
title: 
---
<div class="profile-container">
  <div class="profile-image-container">
    <img src="assets/pfp.jpeg" alt="Profile Photo" class="profile-image">
    <p class="profile-caption">A Photo of the Team</p>
  </div>
  <div class="profile-content">
    <p>
      We are starting a VC Firm
    </p>
    <p>
      Run by Austin Wu, Achyunth Vivek, Caroline Zhu, and Maxx Yung.
    </p>
    <p>
      Please reach out to us, we try to make time for anyone who does. My public inbox is <code><span id="email-display"></span></code>.
    <script>
        // https://www.base64encode.org/
        var encodedEmail = "cHVibGljQGZ1bmRuYW1lLmNvbQ==";
        var decodedEmail = atob(encodedEmail);
        document.getElementById("email-display").innerHTML = decodedEmail;
        var emailLink = document.createElement('a');
        emailLink.href = 'mailto:' + decodedEmail;
        emailLink.textContent = decodedEmail;
        document.getElementById("email-display").innerHTML = '';        document.getElementById("email-display").appendChild(emailLink);
    </script>
    </p>
  </div>
</div>
<br>
*Site last updated: {{ site.time | date: '%B %d, %Y, UTC: %s' }}*
