---
layout: page
title: 
---
<div class="profile-container">
  <!-- <div class="profile-image-container">
    <img src="{{ "/assets/groupPicture.jpeg" | relative_url }}" alt="Profile Photo" class="profile-image">
    <p class="profile-caption">A Photo of the Team</p>
  </div> -->
  <div class="profile-content">
    <p>
      Run by <a href="https://austin-wu.com/">Austin Wu</a>, <a href="https://www.linkedin.com/in/achyuth-k-vivek-15357b326/">Achyuth Vivek</a>, <a href="https://www.linkedin.com/in/caroline-zhu-cu2026/">Caroline Zhu</a>, and <a href="https://www.maxxyung.com/">Maxx Yung</a>,
    </p>
    <p><code><span data-encoding="cHVibGljQGZ1bmRuYW1lLmNvbQ==" id="e1"></span></code> </p>
    <p><code><span data-encoding="YXVzdGluQGZ1bmRuYW1lLmNvbQ==" id="e1"></span></code> </p>
    <p><code><span data-encoding="Y2Fyb2xpbmVAZnVuZG5hbWUuY29t" id="e1"></span></code> </p>
    <p><code><span data-encoding="bWF4eEBmdW5kbmFtZS5jb20=" id="e1"></span></code> </p>
    <p><code><span data-encoding="YWNoeXV0aEBmdW5kbmFtZS5jb20=" id="e1"></span></code> </p>
  </div>
</div>
<script>
  //https://www.base64encode.org/
  document.querySelectorAll('span[data-encoding]').forEach(span => {
    const decoded = atob(span.dataset.encoding);       // 1 Decode
    const link = document.createElement('a');       // 2 Build <a>
    link.href = 'mailto:' + decoded;
    link.textContent = decoded;
    span.replaceWith(link);                         // 3 Swap into place
  });
</script>
<br>
*Site last updated: {{ site.time | date: '%B %d, %Y, UTC: %s' }}*
