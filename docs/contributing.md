-*- mode: markdown; mode: visual-line; -*-

# Backupninja Puppet Module Developments

If you want to contribute to the code, you shall be aware of the way this module is organized.

### Directory Layout

       ulhpc-backupninja/       # Main directory 
           `-- metadata.json     # Module configuration - cf [here](https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file)
           `-- README.md         # This file
           `-- files/            # Contains static files, which managed nodes can download
           `-- lib/              # custom facts/type/provider definitions
           `-- manifests/
                `-- init.pp      # Main manifests file which defines the backupninja class 
                `-- params.pp    # ulhpc-backupninja module variables 
                `-- backupninja.pp 
                `-- common.pp 
                `-- common/debian.pp 
                `-- common/redhat.pp 
                `-- distantlvm.pp 
                `-- ldap.pp 
                `-- mysql.pp 
                `-- pgsql.pp 
                `-- rsync.pp 
           `-- templates/        # Module ERB template files
           `-- tests/            # Contains examples showing how to declare the module’s classes and defined type
           `-- spec/             # Contains rspec tests 
           `-- Rakefile          # Definition of the [rake](https://github.com/jimweirich/rake) tasks
           `-- .ruby-{version,gemset}   # [RVM](https://rvm.io/) configuration
           `-- Gemfile[.lock]    # [Bundler](http://bundler.io/) configuration
           `-- .git/             # Hold git configuration
           `-- .vagrant_init.rb  # Vagrant provisionner to test this module
           `-- Vagrantfile       # Vagrant file

### Git Branching Model

The Git branching model for this repository follows the guidelines of [gitflow](http://nvie.com/posts/a-successful-git-branching-model/).
In particular, the central repository holds two main branches with an infinite lifetime: 

* `production`: the branch holding   tags of the successive releases of this tutorial 
* `devel`: the main branch where the sources are in a state with the latest delivered development changes for the next release. This is the *default* branch you get when you clone the repository, and the one on which developments will take places.

You should therefore install [git-flow](https://github.com/nvie/gitflow), and probably also its associated [bash completion](https://github.com/bobthecow/git-flow-completion).  

### Ruby, [RVM](https://rvm.io/) and [Bundler](http://bundler.io/)

The various operations that can be conducted from this repository are piloted
from a `Rakefile` and assumes you have a running Ruby installation.

The bootstrapping of your repository is based on [RVM](https://rvm.io/), **thus
ensure this tools are installed on your system** -- see
[installation notes](https://rvm.io/rvm/install).

The ruby stuff part of this repository corresponds to the following files:

* `.ruby-{version,gemset}`: [RVM](https://rvm.io/) configuration, use the name of the
  project as [gemset](https://rvm.io/gemsets) name
* `Gemfile[.lock]`: used by `[bundle](http://bundler.io/)`

### Repository Setup

Then, to make your local copy of the repository ready to use the [git-flow](https://github.com/nvie/gitflow) workflow and the local [RVM](https://rvm.io/)  setup, you have to run the following commands once you cloned it for the first time: 

      $> gem install bundler    # assuming it is not yet available
	  $> bundle install
	  $> rake -T                # To list the available tasks
      $> rake setup 

You probably wants to activate the bash-completion for rake tasks.
I personnaly use the one provided [here](https://github.com/ai/rake-completion)

Also, some of the tasks are hidden. Run `rake -T -A` to list all of them. 

### RSpec tests

A set of unitary tests are defined to validate the different function of my library using [Rspec](http://rspec.info/) 

You can run these tests by issuing:

	$> rake rspec  # NOT YET IMPLEMENTED
	
By conventions, you will find all the currently implemented tests in the `spec/` directory, in files having the `_spec.rb` suffix. This is expected from the `rspec` task of the `Rakefile`.

**Important** Kindly stick to this convention, and feature tests for all   definitions/classes/modules you might want to add. 

### Releasing mechanism

The operation consisting of releasing a new version of this repository is
automated by a set of tasks within the `Rakefile`. 

In this context, a version number have the following format:

      <major>.<minor>.<patch>

where:

* `< major >` corresponds to the major version number
* `< minor >` corresponds to the minor version number
* `< patch >` corresponds to the patching version number

Example: `1.2.0`

The current version number is stored in the file `metadata.json`. 
For more information on the version, run:

     $> rake version:info

If a new  version number such be bumped, you simply have to run:

     $> rake version:bump:{major,minor,patch}

This will start the release process for you using `git-flow`.
Then, to make the release effective, just run:

     $> rake version:release

This will finalize the release using `git-flow`, create the appropriate tag and merge all things the way they should be. 

# Contributing Notes

This project is released under the terms of the [GPL-3.0 Licence](LICENSE). 
So you are more than welcome to contribute to its development as follows: 

1. Fork it
2. Create your feature branch (`rake git:feature:start[<feature_name>]`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git flow feature publish <feature_name>`)
5. Create new Pull Request

