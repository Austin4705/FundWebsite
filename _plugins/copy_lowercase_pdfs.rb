Jekyll::Hooks.register :site, :post_write do |site|
  # Get the destination directory
  dest = site.dest
  
  # Handle PDFs for blog posts - copy them to the same directory as the HTML
  site.posts.docs.each do |post|
    post_basename = File.basename(post.path, '.md')
    pdf_source = File.join(site.source, '_posts', "#{post_basename}.pdf")
    
    if File.exist?(pdf_source)
      # Get the post's output directory (same as where the HTML is generated)
      post_output_dir = File.dirname(post.destination(dest))
      
      # Get the HTML filename without extension (this removes the date prefix)
      html_basename = File.basename(post.destination(dest), '.html')
      
      # Copy the PDF with the same basename as the HTML
      pdf_dest = File.join(post_output_dir, "#{html_basename}.pdf")
      
      puts "Copying blog PDF: #{post_basename}.pdf to #{post_output_dir}/#{html_basename}.pdf"
      FileUtils.mkdir_p(post_output_dir)
      FileUtils.cp(pdf_source, pdf_dest)
      
      # Also create lowercase copy if needed
      lowercase_filename = "#{html_basename}.pdf".downcase
      if "#{html_basename}.pdf" != lowercase_filename
        lowercase_path = File.join(post_output_dir, lowercase_filename)
        puts "Creating lowercase copy: #{lowercase_filename}"
        FileUtils.cp(pdf_source, lowercase_path)
      end
    end
  end
  
  # Find all PDF files in the notes directory
  notes_dir = File.join(dest, 'notes')
  
  if Dir.exist?(notes_dir)
    Dir.glob(File.join(notes_dir, '*.pdf')).each do |pdf_file|
      filename = File.basename(pdf_file)
      lowercase_filename = filename.downcase
      
      # Only create lowercase copy if it doesn't already exist and names are different
      if filename != lowercase_filename
        lowercase_path = File.join(File.dirname(pdf_file), lowercase_filename)
        
        unless File.exist?(lowercase_path)
          puts "Creating lowercase copy: #{lowercase_filename}"
          FileUtils.cp(pdf_file, lowercase_path)
        end
      end
    end
  end
  
  # Also handle PDFs in the root directory
  Dir.glob(File.join(dest, '*.pdf')).each do |pdf_file|
    filename = File.basename(pdf_file)
    lowercase_filename = filename.downcase
    
    if filename != lowercase_filename
      lowercase_path = File.join(File.dirname(pdf_file), lowercase_filename)
      
      unless File.exist?(lowercase_path)
        puts "Creating lowercase copy: #{lowercase_filename}"
        FileUtils.cp(pdf_file, lowercase_path)
      end
    end
  end
end 