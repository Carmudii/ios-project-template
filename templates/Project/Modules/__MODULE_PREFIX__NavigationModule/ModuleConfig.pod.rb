# Documentation for the Target module
#
# @author = 'carmudi'
# @email = 'carmudi@engineer.com'
#
# This module represents the target configuration for the __MODULE_PREFIX__NavigationModule module.
# It contains information such as the name, project file, and dependencies.
#
# Example usage:
#   Target.name            # returns the name of the target
#   Target.projectFile     # returns the project file of the target
#   Target.dependencies    # returns an array of dependencies for the target
#

module Target
    @name = '__MODULE_PREFIX__NavigationModule'
    @projectFile = '__MODULE_PREFIX__NavigationModule.xcodeproj'
    @dependencies = [
    # 'core.RxCocoa',
    # 'core.RxSwift',
    'core.Swinject',
    # 'core.SwinjectAutoregistration'
    ]

    class << self
        attr_reader :name, :projectFile, :dependencies
    end
end
