/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, Text, StyleSheet, Button, Alert, } from 'react-native'
import { Actions } from 'react-native-router-flux'

// notify
import { nofifyModule } from '../../modules'

// const 
const { 
	registerReceiveRemoteNofity, registerClickRemoteNotify,
	removeReceiveRemoteNofify, removeClickRemoteNotify,
} = nofifyModule

class FirstContainer extends Component{

	componentDidMount(){
		// 注册消息
		registerReceiveRemoteNofity(this._notifyReceive)
		registerClickRemoteNotify(this._notifyClick)
	}

	componentWillUnmount(){
		// 移除通知
		removeReceiveRemoteNofify(this._notifyReceive)
		removeClickRemoteNotify(this._notifyClick)
	}

	_notifyReceive = (notification)=>{
		Alert.alert(
			'payload 通知',
			`内容${JSON.parse(notification)}`,
			[
				{text: 'Cancel', onPress: ()=> null}
			],
			{cancelable: false}
		)
	}

	_notifyClick = (notification)=>{
		Alert.alert(
			'click通知',
			`内容${JSON.parse(notification)}`,
			[
				{text: 'Cancel', onPress: ()=> null}
			],
			{cancelable: false}
		)
	}

	render(){
		return (
			<View style={styles.container}>
				<Text>First page.</Text>
				<Button onPress={Actions.second} title='To Second' />
			</View>
		)
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center'
	}
})

export default FirstContainer