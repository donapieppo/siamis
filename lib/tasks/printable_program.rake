namespace :siamis do
  namespace :program do

    desc "Printable A3 program"
    task a3_program: :environment do
      pdf = PrintableProgram.new()
      pdf.render_file('public/siamis18_a3_program.pdf')
    end
  end
end
