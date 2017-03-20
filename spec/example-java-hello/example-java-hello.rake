namespace :example_java_hello do
  sample_app = 'example-java-hello'

  def alert_package_missing
    unless provided?("java")
      SimpleLog.log.warn "There is no package that provides java, skipping"
    end
  end

  desc "Install the #{sample_app} sample application."
  task :install do
    alert_package_missing

    provided("java") do
      cd(sample_app) do
        apc "app create #{sample_app} --disable-routes"
        apc "app start #{sample_app}"
      end
    end
  end

  desc "Test the #{sample_app} sample application after it is deployed."
  task :test do
    alert_package_missing

    provided("java") do
      rspec sample_app
    end
  end

  desc "Teardown the #{sample_app} sample application."
  task :teardown do
    alert_package_missing

    provided("java") do
      cd(sample_app) do
        apc "app delete #{sample_app}"
      end
    end
  end

  task :all => [:install, :test, :teardown]
end

desc "Install, test, and teardown the example-java-hello sample application."
task :example_java_hello => 'example_java_hello:all'