
import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import leafletImage from "leaflet-image"

export default class extends Controller {
  static values = {
    earthquakeId: Number,
    lat: Number,
    lng: Number,
    title: String
  }

  connect() {
    const map = L.map(this.element).setView([this.latValue, this.lngValue], 9)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors",
      maxZoom: 19
    }).addTo(map)
    L.marker([this.latValue, this.lngValue]).addTo(map)

      leafletImage(map, (err, canvas) => {
        if (err) { console.error(err); return }

        const dataUrl = canvas.toDataURL()
        const img = document.createElement("img")
        img.src = dataUrl
        img.classList.add("img-fluid", "rounded", "shadow", "mt-2")
      })
  }

  uploadImage(dataURL) {
    const blob = this.dataURLToBlob(dataURL)
    const formData = new FormData()
    formData.append("image", blob)

    fetch(`/earthquake/${this.earthquakeIdValue}/upload_map_image`, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      }
    })
  }

  dataURLToBlob(dataURL) {
    const parts = dataURL.split(";base64,")
    const contentType = parts[0].split(":")[1]
    const byteString = atob(parts[1])
    const ab = new ArrayBuffer(byteString.length)
    const ia = new Uint8Array(ab)
    for (let i = 0; i < byteString.length; i++) ia[i] = byteString.charCodeAt(i)
    return new Blob([ab], { type: contentType })
  }
}
