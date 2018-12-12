/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, Text, StyleSheet, Button, Alert,} from 'react-native'
import { Actions } from 'react-native-router-flux'
import Getui from 'react-native-getui'

class LoginContainer extends Component{

	componentDidMount(){
		// 获取 getui clientID 用于传给服务端 记录
		Getui.clientId((param)=>{
			Alert.alert(
				'个推 推送',
				`clientId=${param}`,
				[
					{text: 'Ask me later', onPress: ()=> null},
					{text: 'Cancel', onPress: ()=> null, style: 'cancel'},
					{text: 'Ok', onPress: ()=> null},
				],
				{cancelable: false}
			)
		})
	}

	render(){
		return (
			<View style={styles.container}>
				<Text>Login page.</Text>
				<Button onPress={Actions.first} title='To First' />
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

export default LoginContainer