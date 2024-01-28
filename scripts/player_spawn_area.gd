extends Area2D

# Sets is_empty is there are no bodies overlapping 
var is_empty : bool:
	get:
		return ( !has_overlapping_areas() && !has_overlapping_bodies() )
