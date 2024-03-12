# Version of library
Version = {
    core: {
        RxSwift: '5.1.3',
        RxCocoa: '5.1.3',
        Swinject: '2.8.3',
        SwinjectAutoregistration: '2.8.3',
    }
}

# Library hash contains the libraries to be added to the podfile
Library = {
    core: {
        'RxSwift' => Version[:core][:RxSwift],
        'RxCocoa' => Version[:core][:RxCocoa],
        'Swinject' => { git: 'https://github.com/Swinject/Swinject.git', tag: Version[:core][:Swinject] },
        'SwinjectAutoregistration' => Version[:core][:SwinjectAutoregistration],
    }
#   Add more libraries below here if you want add a isolate library for each module
#   Don't forget to add the version in the Version variable too
#   secondary: {
#       'SwiftLint' => { git: 'https://github.com/realm/SwiftLint.git', tag: '0.41.0' }
#   }
}

# DOCUMENTATION
#
# This method takes in the podfileContext, targetModule, and dependency as parameters.
# It checks if the dependency exists in the Library hash.
# If the dependency does not exist, it raises an error and prints an error message.
# If the dependency exists, it retrieves the corresponding library from the Library hash.
# It then checks if the library exists in the dependency.
# If the library does not exist, it raises an error and prints an error message.
# If the library exists, it adds the library to the podfileContext using the pod method.
#
# @param [Object] podfileContext The context of the Podfile.
# @param [String] targetModule The name of the target module.
# @param [String] dependency The dependency of the library in the Library hash.
def library(podfileContext, targetModule, dependency)
    keys = dependency.split('.')
    location = keys.first.to_sym
    library = keys.last
    libs = Library

    unless libs.key?(location)
        puts "\e[31m !!!!!!! #{targetModule} -> dependency: #{dependency} not found in Library. \e[0m"
        raise StandardError.new("dependency not found in Library: #{dependency}")
    end

    libs = libs[location]
    unless libs.key?(library)
        puts "\e[31m !!!!!!! #{targetModule} -> library: #{library} not found in dependency: #{location} \e[0m"
        raise StandardError.new("Library '#{library}' not found in dependency '#{location}'")
    end

    podfileContext.pod library, libs[library]
end

# DOCUMENTATION
#
# This method checks if a file exists at the given path.
# If the file does not exist, it prints an error message and returns false.
# If the file exists, it returns true.
#
# @param [String] path The path of the file to check.
# @return [Boolean] True if the file exists, false otherwise.
def isFileExists?(path)
    if !File.exist?(path)
        return false
    end
    return true
end

# DOCUMENTATION
#
# This method adds a target to the Podfile.
# It takes in the podfileContext and the targetPath as parameters.
# It first checks if the build.pod.rb file exists at the targetPath.
# If the file does not exist, it returns an empty array.
# If the file exists, it loads the file and prints a message indicating the target name.
# It then defines a lambda function that will be executed in the context of the podfileContext.
# Inside the lambda function, it defines a target with the name obtained from the Target class.
def addTarget(podfileContext, targetPath)
    filePath = "#{targetPath}/build.pod.rb"
    
    if !isFileExists?(filePath)
        puts "\e[31m !!!!!!! Configuration file: #{filePath} does not exists. \e[0m"
        raise StandardError.new("Please check the configuration file at path: #{filePath} and make sure it exists")
    end

    load filePath
    puts "** Add dependencies to module target #{Target.name}"
    podfileContextLambda = lambda do

        target Target.name do
            projectPath = "#{targetPath}/#{Target.projectFile}"

            if !isFileExists?(filePath)
                puts "\e[31m !!!!!!! Project file: #{projectPath} does not exists. \e[0m"
                raise StandardError.new("Please check the project file at path: #{projectPath} and make sure it exists")
            end

            project projectPath
            use_frameworks!
            Target.dependencies.each do |dependency|
                puts "\e[32m- #{dependency}\e[0m"
                library(self, Target.name, dependency)
            end
        end
    end
    podfileContext.instance_exec(&podfileContextLambda)
    Target.dependencies
end
