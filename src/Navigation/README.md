# Elm_React_Navigation

## Let's run Navigation!

### Introduction
At first, open the following URL.

https://github.com/vitoria-training/Experiment-Elm/tree/develop#get-starting-with-elm

Let's copy the following remote repository from the code button.

https://github.com/vitoria-training/Experiment-Elm.git

Open your terminal like command prompt after you have copied it.
And run the following command at the location where you want to clone the repository.
```
git clone -b develop https://github.com/vitoria-training/Experiment-Elm.git
```

### Run program
Please navigate to the repository you just cloned using the following command.
```
cd Experiment-elm
```
Please next command
```
cd examples\Navigation
```
To run elm program
```
elm reactor
```
If port 8000 cannot be used for some reason, you use the following command.

such as
```
elm reactor --port=8080
```
When `elm reactor` is executed, the message `Go to http://localhost:8000 to see your project dashboard.` will appear, so hold down the `ctrl` key and click on the `http://localhost:8000` part.

After you clicked on the `http://localhost:8000`, there are two program files as follows:
- Navigation.elm
- URLParser.elm

Let's open those elm files and run those program!

### Program contents
Navigation.elm is changed the URL when you click the link.

URLParser.elm is changed the URL and moved the screen when you click the link.
