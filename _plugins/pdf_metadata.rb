Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  # Get the basename of the post (without .md extension)
  post_basename = File.basename(post.path, '.md')
  
  # Check if a PDF with the same name exists in _posts
  pdf_path = File.join(post.site.source, '_posts', "#{post_basename}.pdf")
  
  if File.exist?(pdf_path)
    # Add a custom variable to indicate PDF exists
    post.data['has_pdf'] = true
    # Use the post's URL directory + the slug (title without date) + .pdf
    post_url_dir = File.dirname(post.url)
    post.data['pdf_url'] = "#{post_url_dir}/#{post.data['slug']}.pdf"
  end
end 