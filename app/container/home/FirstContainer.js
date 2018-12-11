/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, Text, StyleSheet, Button, } from 'react-native'
import { Actions } from 'react-native-router-flux'

class FirstContainer extends Component{
	render(){
		return (
			<View style={styles.container}>
				<Text>First page.</Text>
				<Button onPress={Actions.second} title='To Second' />
				<Button onPress={Actions.map} title='To Map' />
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