---
layout: page
title: 
---
<div class="profile-container">
  <div class="profile-image-container">
    <img src="assets/pfp.jpeg" alt="Profile Photo" class="profile-image">
    <p class="profile-caption">A Photo of Me</p>
  </div>
  <div class="profile-content">
    <p>
      I am an undergrad at Cornell from the South Bay Area pursuing a B.S. in Applied and Engineering Physics and a minor in Math.
    </p>
    <p>
      My interests range broadly across stem with a concentration in hardware, specializing in Experimental Topological Condensed Matter. I also do work in Ex-AMO Physics, Systems, FPGA, and Robotics.
    </p>
    <p>
      Along with my core interests in applied subjects, I have fundamental interests in theory. Notably: Many Body Quantum Systems, Differential and Algebraic Topology, Computer Architecture, Controls, and Distributed Systems.
    </p>
    <p>
    I am fortunate to be advised by Professor Kenji Yasuda, Professor Or Katz, and Professor Linda Ye. Currently, I am at Caltech for an REU (SURF)
    </p>
    <p>
      Outside of my academic interests, I run and travel frequently. I also engage with startups.
    </p>
    <p>
      I highly encourage you to reach out, I try to make time for anyone who does. My public inbox is <code><span id="email-display"></span></code>. Alternatively just reach out on <a href="https://www.linkedin.com/in/austin--wu/">LinkedIn</a>.
    <script>
        var encodedEmail = "cHVibGljQGF1c3Rpbi13dS5jb20=";
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
