/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, Text, StyleSheet, Button, } from 'react-native'
import { Actions } from 'react-native-router-flux'

class LoginContainer extends Component{
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