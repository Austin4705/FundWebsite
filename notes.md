---
layout: default
title: Notes 
permalink: /notes/
---
# Research Notes & Academic Resources

> **Note:** I am still an undergraduate in college and not necessarily an expert on any of these topics. While you can assume they are mostly accurate, because of this please do not necessarily consider this a perfectly accurate source

This page contains my collection of academic notes, research summaries, and useful resources in physics, mathematics, and engineering. They will either be in Latex, Markdown page or sometimes rarely PDF scratch work. If there is an attached PDF, the document was written in LaTeX, and any Markdown version is just an automatic Pandoc compilation, so it might be better to read that as that is the main version I check for compilation errors. Please inform me of any typos or incorrect information.

Check back regularly for new additions as I update this section with my latest notes and findings.

<div class="home">
  {%- if site.notes.size > 0 -%}
    <h2 class="note-list-heading">{{ page.list_title | default: "Notes" }}</h2>
    <ul class="note-list">
      {%- for note in site.notes-%}
      <li>
        {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
        <span class="note-meta">{{ note.date | date: date_format }}</span>
        <h3>
          <a class="note-link" href="{{ note.url | relative_url }}" style="color: inherit; text-decoration: none;">
            <u>{{ note.title | escape }}</u>
          </a>
          {%- comment %} Check for matching PDF file {% endcomment -%}
          {%- assign note_path_without_collection = note.path | remove_first: "_" | remove_first: note.collection | remove_first: "/" -%}
          {%- assign note_basename = note_path_without_collection | replace: ".md", "" -%}
          {%- assign expected_pdf_path = "_notes/" | append: note_basename | append: ".pdf" -%}

          {%- for static_file in site.static_files -%}
            {%- if static_file.path == expected_pdf_path -%}
              {%- assign pdf_url = "/notes/" | append: note_basename | append: ".pdf" | relative_url -%}
              <a href="{{ pdf_url }}" class="pdf-link" target="_blank" style="margin-left: 5px;">(pdf)</a>
              {%- break -%}
            {%- endif -%}
          {%- endfor -%}
          <!-- {%- comment %} Check for matching raw markdown file {% endcomment -%}
          {%- assign markdown_url = "/notes/" | append: note_basename | append: ".md" | relative_url -%}
          <a href="{{ markdown_url }}" class="markdown-link" target="_blank" style="margin-left: 5px;">(raw markdown)</a> -->
        </h3>
        {%- if site.show_excerpts -%}
          {{ note.excerpt }}
        {%- endif -%}
      </li>
      {%- endfor -%}
    </ul>
  {%- else -%}
    <p>No notes yet. Check back soon!</p>
  {%- endif -%}
</div>
