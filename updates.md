---
layout: default
title: Updates
permalink: /updates/
---
This is intended for firm updates.
<div class="home">
  {%- if site.posts.size > 0 -%}
    <h2 class="note-list-heading">{{ page.list_title | default: "Posts" }}</h2>
    <ul class="note-list">
      {%- for post in site.posts-%}
      <li>
        {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
        <span class="note-meta">{{ post.date | date: date_format }}</span>
        <h3>
          <a class="note-link" href="{{ post.url | relative_url }}" style="color: inherit; text-decoration: none;">
            <u>{{ post.slug | replace: "-", " " | capitalize }}</u>
          </a>
          {%- if post.has_pdf -%}
            <a href="{{ post.pdf_url | relative_url }}" class="pdf-link" target="_blank" style="margin-left: 5px;">(pdf)</a>
          {%- endif -%}
        </h3>
        {%- if site.show_excerpts -%}
          {{ post.excerpt }}
        {%- endif -%}
      </li>
      {%- endfor -%}
    </ul>
  {%- else -%}
    <p>No blog posts yet. Check back soon!</p>
  {%- endif -%}
</div>
