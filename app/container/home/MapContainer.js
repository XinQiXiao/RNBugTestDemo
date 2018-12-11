/**
 * create at 11/30/18
 */
import React, { Component } from 'react'
import { View, StyleSheet, Dimensions, } from 'react-native'
import { MapView, MapTypes,} from 'react-native-baidu-map'

// const 
const DeviceHeight = Dimensions.get('window').height
const DeviceWidth = Dimensions.get('window').width

class MapContainer extends Component{



	render(){
		return (
			<View style={styles.container}>
				<MapView 
					mapType={MapTypes.NORMAL}
					zoom={15}
					center={{longitude: 116.17, latitude: 39.57}}
					onMapStatusChange={()=> null}
					onMapStatusChangeFinish={()=> null}
					style={{width: DeviceWidth, height: DeviceHeight}}
				/>
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

export default MapContainer