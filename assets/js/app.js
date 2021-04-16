// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
// //
// import { Socket } from "phoenix"
// import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import topbar from "topbar"
import { LiveSocket } from "phoenix_live_view"
import mapboxgl from 'mapbox-gl'


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}
Hooks.MapHook = {
  mounted() {
    const map = new mapboxgl.Map({
      container: 'map_live_div',
      style: 'http://localhost:8085/styles/klokantech-basic/style.json',
      center: [28.8638, 47.0105],
      zoom: 12
    });

    map.on('load', function () {


    });
    //map.addControl(new mapboxgl.FullscreenControl());
    const handleEvent = ({ tevent }) => {
      console.log(tevent)
      if (map.getSource(tevent.board) == undefined) {
        var dd = { 'type': 'Point', 'coordinates': [tevent.longitude, tevent.latitude] }

        map.addSource(tevent.board, { type: 'geojson', data: dd });
        map.addLayer({
          'id': tevent.board,
          'type': 'circle',
          'source': tevent.board,
          'paint': {
            'circle-radius': 8,
            'circle-color': '#007cbf'
          }
        });
        return
      }
      var dd = { 'type': 'Point', 'coordinates': [tevent.longitude, tevent.latitude] }

      map.getSource(tevent.board).setData(dd)
      // map.flyTo({
      //   center: [tevent.longitude, tevent.latitude],
      //   speed: 0.5
      // });
    }

    this.handleEvent("new_coordinates", handleEvent)
  }
}

let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

