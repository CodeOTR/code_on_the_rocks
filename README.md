# Code on the Rocks
A bold and balanced state management library that pairs the MVVM structures of Stacked with the simplicity of GetIt.

## Inspiration
Over the years I've become a big fan of several different "state-management" packages:

- I like the MVVM-focused widgets from [Stacked](https://pub.dev/packages/stacked) (ViewModel, ViewModelBuilder, ViewModelWidget)
- I like the accessibility of objects stored in GetIt ([get_it](https://pub.dev/packages/get_it))
- I like how [get_it_mixin](https://pub.dev/packages/get_it_mixin) gives you granular control over your UI from anywhere in your app

I used Stacked and GetIt in all of my apps for a while but there were a few problems. 
1. Stacked is more than a state management library. It has built-in solutions for dependency injection, navigation, and forms, as well as a CLI to help you create views and services the Stacked way. While it was amazing to use, it was opinionated and didn't leave much room for exploration. 
2. I found myself wanting to make my UI react to changes in higher-level services using GetItMixin. This lead to a messy situation where widgets were being updated by ViewModelBuilders, ViewModelWidgets, and StatelessWidgets with the GetItMixin. It just didn't feel right.
3. Registering a Singleton using just GetIt and no ViewModelBuilder required a lot of boiler plate built around a StatefulWidget. The Singleton needed to be registered in initState and disposed of. Plus, whenever I wanted to create a Singleton with initial parameters, I needed to double check that the previously registered Singleton had been reset. This stuff wasn't complicated but it was a headache.

This package was created to address these concerns. It is a single dart file with two classes: a ViewModel and a ViewModelBuilder. 
- ViewModels are just ChangeNotifiers with an `isLoading` property
- ViewModelBuilders are basically just ListenableBuilders connected to a ViewModel. Under the hood, they are StatefulWidgets that will register and unregister their corresponding ViewModel according to the widget's lifecycle.

## The Big Difference
What makes this package different from Stacked (aside from its drastically reduced size and complexity) is that all ViewModels used by ViewModelBuilders are:
1. Registered in GetIt when the ViewModelBuilder is created
2. Unregistered from GetIt when the ViewModelBuilder is disposed
Now there is no technical or architectural difference between services in your service locator or ViewModels used by your UI. All of these classes are registered in GetIt just the same. This also means you can use the GetItMixin in nested widgets to selectively react to changes in your ViewModel (this serves the same purpose as the ViewModelWidget in Stacked).

## Usage
