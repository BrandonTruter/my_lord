WickedPdf.config = {
  :exe_path => (Rails.env.development? ? Rails.root.join('bin', 'wkhtmltopdf').to_s : '/usr/local/bin/wkhtmltopdf')
}