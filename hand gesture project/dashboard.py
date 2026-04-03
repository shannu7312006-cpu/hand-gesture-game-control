import streamlit as st
import folium
import numpy as np
from streamlit_folium import st_folium

st.set_page_config(page_title="Zomato GPS Tracking", layout="wide")

st.title("📍 Zomato Live GPS Delivery Tracking")

st.write("Each click simulates a new GPS update from the delivery partner.")

# ---------------- LOCATIONS ----------------
restaurant = np.array([12.9716, 77.5946])   # Restaurant
customer   = np.array([12.9616, 77.5846])   # Customer

# ---------------- CREATE ROUTE ----------------
steps = 25
lat_points = np.linspace(restaurant[0], customer[0], steps)
lon_points = np.linspace(restaurant[1], customer[1], steps)
route = list(zip(lat_points, lon_points))

# ---------------- SESSION STATE ----------------
if "position" not in st.session_state:
    st.session_state.position = 0

# ---------------- BUTTONS ----------------
col1, col2 = st.columns(2)

with col1:
    move = st.button("➡ Move GPS (Next Update)")

with col2:
    reset = st.button("🔄 Reset Tracking")

if reset:
    st.session_state.position = 0

if move and st.session_state.position < len(route) - 1:
    st.session_state.position += 1

current_location = route[st.session_state.position]

# ---------------- MAP ----------------
m = folium.Map(location=current_location, zoom_start=15)

folium.Marker(
    restaurant,
    popup="Restaurant",
    icon=folium.Icon(color="green")
).add_to(m)

folium.Marker(
    customer,
    popup="Customer",
    icon=folium.Icon(color="red")
).add_to(m)

folium.Marker(
    current_location,
    popup="Delivery Partner",
    icon=folium.Icon(color="blue", icon="bicycle")
).add_to(m)

folium.PolyLine(
    route[:st.session_state.position + 1],
    color="blue",
    weight=5
).add_to(m)

st_folium(m, width=750, height=500)

# ---------------- ETA ----------------
speed = st.slider("🚴 Delivery Speed (km/hr)", 10, 40, 20)
remaining_distance_km = ((len(route) - st.session_state.position) / len(route)) * 3
eta = (remaining_distance_km / speed) * 60

st.success(f"⏱ Estimated Time Remaining: {int(eta)} minutes")

if st.session_state.position == len(route) - 1:
    st.balloons()
    st.success("✅ Order Delivered Successfully!")
