title 'Tests to confirm libxml2 binary works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "libxml2")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-libxml2' do
  impact 1.0
  title 'Ensure libxml2 binary is working as expected'
  desc '
  We first check that the libxml2 binary we expect is present and then run version checks on both to verify that it is excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty}
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  libxml2_config_exists = command("ls -al #{File.join(target_dir, "xml2-config")}")
  describe libxml2_config_exists do
    its('stdout') { should match /xml2-config/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  xml2_config_works = command("/bin/xml2-config --version")
  describe xml2_config_works do
    its('stdout') { should match /[0-9]+.[0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  xmlcatalog_exists = command("ls -al #{File.join(target_dir, "xmlcatalog")}")
  describe xmlcatalog_exists do
    its('stdout') { should match /xmlcatalog/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  xmlcatalog_works = command("/bin/xmlcatalog -v")
  describe xmlcatalog_works do
    its('stdout') { should be_empty }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  xmllint_exists = command("ls -al #{File.join(target_dir, "xmllint")}")
  describe xmllint_exists do
    its('stdout') { should match /xmllint/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  xmllint_works = command("/bin/xmllint --version")
  describe xmllint_works do
    its('stdout') { should be_empty }
    its('stderr') { should match /\/bin\/xmllint: using libxml version [0-9]+/ }
    its('exit_status') { should eq 0 }
  end
end
