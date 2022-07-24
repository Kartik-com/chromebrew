require 'package'

class Android_studio < Package
  description 'Android Studio is the official IDE for Android development.'
  homepage 'https://developer.android.com/studio'
  version '2021.2.1.15'
  license 'Apache-2.0'
  compatibility 'x86_64'
  source_url 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-linux.tar.gz'
  source_sha256 '0018e0dfc0dd2921700516f7a2c443377c557788da7fb0a45243ecb4300745be'

  depends_on 'jdk11'
  depends_on 'xdg_base'
  depends_on 'sommelier'

  def self.preflight
    free_space = `echo $(($(stat -f --format="%a*%S" #{CREW_PREFIX})))`.chomp.to_i
    abort 'Not enough free disk space.  You need at least 6 GB to install.'.lightred if free_space < 6442450944
  end

  def self.install
    FileUtils.mkdir_p CREW_DEST_PREFIX + '/bin'
    FileUtils.mkdir_p CREW_DEST_PREFIX + '/share/android-studio'
    FileUtils.mv 'bin', CREW_DEST_PREFIX + '/share/android-studio'
    FileUtils.mv 'lib', CREW_DEST_PREFIX + '/share/android-studio'
    FileUtils.mv 'plugins', CREW_DEST_PREFIX + '/share/android-studio'
    FileUtils.cd CREW_DEST_PREFIX + '/bin' do
      FileUtils.ln_s CREW_PREFIX + '/share/android-studio/bin/studio.sh', 'studio'
    end
  end

  def self.postinstall
    puts "\nTo finish the installation, execute the following:".lightblue
    puts "source #{HOME}/.bashrc".lightblue
    puts "\nTo start using Android Studio, type `studio`.\n".lightblue
  end

  def self.remove
    print "Would you like to remove the config directories? [y/N] "
    response = STDIN.getc
    config_dirs = ["#{HOME}/.android", "#{HOME}/Android"]
    config_dirs.each { |config_dir|
      if Dir.exist? config_dir
        case response
        when "y", "Y"
          FileUtils.rm_rf config_dir
          puts "#{config_dir} removed.".lightred
        else
          puts "#{config_dir} saved.".lightgreen
        end
      end
    }
  end
end
