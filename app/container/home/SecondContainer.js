/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, Text, StyleSheet, } from 'react-native'

class SecondContainer extends Component{

	componentDidMount(){
		// console.log('SecondContainer componentDidMount this=>', this.props)
	}

	render(){
		return (
			<View style={styles.container}>
				<Text>Second page.</Text>
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

export default SecondContainer