namespace :siamis do
  namespace :users do

    desc "Change user password"
    task commettee_password: :environment do
      r = Random.new
      %W(omar@ices.utexas.edu fiorella.sgallari@unibo.it marcelo.bertalmio@upf.edu pcha@dtu.dk j.kaipio@auckland.ac.nz eric.miller@tufts.edu nikolova@cmla.ens-cachan.fr ronny.ramlau@ricam.oeaw.ac.at cbs31@cam.ac.uk xuechengtai@hkbu.edu.hk waller@berkeley.edu brendt@lanl.gov serena.morigi@unibo.it sciacchitano@dima.unige.it).each do |mail|
        user = User.where(email: mail).first
        user or next
        pass = r.rand(100000..900000)
        user.password = pass
        user.password_confirmation = pass
        user.save
        puts mail + ": " + pass.to_s
      end
    end
  end
end


