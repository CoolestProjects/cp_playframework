cp_playframework Cookbook
==============
Chef Cookbook to deploy Play Framework Applications
This cookbook deploys [playframework 2](http://www.playframework.com) Application

## Attributes

````
 * default['play_app']['install_dir'] = "/opt/coolestprojects"
 * default['play_app']['dist_url'] = ""
 * default['play_app']['dist_local_file_path'] = ""
 * default['play_app']['use_local_dist'] = "true"
 * default['play_app']['application_name'] = ''
 * default['play_app']['app_dir'] = ''
 * default['play_app']['config_dir'] = 'config'
 * default['play_app']['vm_options']='-J-Xms512M -J-Xmx1024M -J-Xss1M'
 * default['play_app']['pid_file_path']="/var/run/play.pid"
 * default['play_app']['application_secret_key']="Your Secret Key here"
 * default['play_app']['play_log_level']="INFO"  
 * default['play_app']['app_log_level']="DEBUG"
 * default['play_app']['play_log_dir']="/var/log/"
 * default['play_app']['max_logging_history']="10"
 * default['play_app']['language']="en"
 * default['play_app']['port']="9000" 
 * default['play_app']['override_config'] = {}
 * default['play_app']['app_version'] = ""
````

## Recipes

  * default.rb - installs the play application
  * restart.rb - restarts the play application 
 
## Thanks

Thanks to Sameer Arora (https://github.com/BluePi/PlayChef) whoise original recipe formed the basis for this one.

License and Authors
-------------------
Author:: Noel King

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=======
