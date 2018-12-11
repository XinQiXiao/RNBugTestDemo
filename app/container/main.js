/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { ToastAndroid } from 'react-native'
import { Router, Scene, Modal, Reducer, ActionConst } from 'react-native-router-flux'
import TimerMixin from 'react-timer-mixin'

/// container
// login
import LoginContainer from './login/LoginContainer'
// first
import FirstContainer from './home/FirstContainer'
// second
import SecondContainer from './home/SecondContainer'
// map
import MapContainer from './home/MapContainer'

// const 
const reducerCreate = params => {
	const defaultReducer = Reducer(params)
	return (state, action) => {
			switch (action.type) {
					case ActionConst.REPLACE:
					case ActionConst.RESET:
					case ActionConst.PUSH:
							break;
					case ActionConst.BACK_ACTION:
							break;
					default:
							break;
			}
			return defaultReducer(state, action);
	}
}
// 过场动画
const animationStyle = (props) => {
	const {layout, position, scene} = props;

	const direction = (scene.navigationState && scene.navigationState.direction) ?
			scene.navigationState.direction : 'horizontal'

	const index = scene.index
	const inputRange = [index - 1, index, index + 1];
	const width = layout.initWidth
	const height = layout.initHeight

	const opacity = position.interpolate({
			inputRange,
			//default: outputRange: [1, 1, 0.3],
			outputRange: [1, 1, 1],
	});

	const scale = position.interpolate({
			inputRange,
			//default: outputRange: [1, 1, 0.95],
			outputRange: [1, 1, 1],
	});

	let translateX = 0;
	let translateY = 0;

	switch (direction) {
			case 'horizontal':
					translateX = position.interpolate({
							inputRange,
							//default: outputRange: [width, 0, -10],
							outputRange: [width, 0, 0],
					});
					break;
			case 'vertical':
					translateY = position.interpolate({
							inputRange,
							//default: outputRange: [height, 0, -10],
							outputRange: [height, 0, 0],
					})
					break
	}

	return {
			opacity,
			transform: [
					{scale},
					{translateX},
					{translateY},
			],
	};
};

class MainComponent extends Component{
	exit = false 
	mixin = TimerMixin

	_onExitApp = ()=> {
		if(this.exit)
			return false 
		this.exit = true 
		this.mixin.setTimeout(()=> this.exit = false, 5 * 1000) 
		ToastAndroid.show('再按一次退出应用', ToastAndroid.SHORT)
		return true
	}

	render(){
		return (
			<Router createReducer={reducerCreate} onExitApp={this._onExitApp} animationStyle={animationStyle}>
				<Scene key='modal' component={Modal}>
					<Scene key='root'>
						<Scene key='login' initial component={LoginContainer}/>
						<Scene key='first' component={FirstContainer}/>
						<Scene key='second' component={SecondContainer}/>
						<Scene key='map' component={MapContainer}/>
					</Scene>
				</Scene>
			</Router>
		)
	}
}

export default MainComponent