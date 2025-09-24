// app/javascript/controllers/chart_controller.js
import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js';
import 'chartjs-adapter-date-fns';

Chart.register(...registerables);

export default class extends Controller {
  static targets = [ "canvas" ] // Declare the canvas target
  static values = { earthquakes: Array }

  connect() {
    this.renderChart();
  }

  renderChart() {
    const data = this.earthquakesValue;

    const canvas = this.canvasTarget;
    const ctx = canvas.getContext('2d');

    const counts = {
      '0-1': 0,
      '1-2': 0,
      '2-3': 0,
      '4-5': 0,
      '5-6': 0,
      '6-7': 0,
      '7-8': 0,
      '8-9': 0,
      '9-10': 0,
    };

    data.forEach(eq => {
      const magnitude = parseInt(eq.magnitude);
      if (magnitude === 0) {
        counts['0-1']++;
      } else if (magnitude === 1) {
        counts['1-2']++;
      } else if (magnitude === 2) {
        counts['2-3']++;
      } else if (magnitude === 3) {
        counts['3-4']++;
      } else if (magnitude === 4) {
        counts['4-5']++;
      } else if (magnitude === 5) {
        counts['5-6']++;
      } else if (magnitude === 6) {
        counts['6-7']++;
      } else if (magnitude === 7) {
        counts['7-8']++;
      }else if (magnitude === 8) {
        counts['8-9']++;
      }else if (magnitude === 9) {
        counts['9-10']++;
      }
    });

    const labels = Object.keys(counts);
    const chartData = Object.values(counts);

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Number of Earthquakes',
          data: chartData,
          backgroundColor: 'rgba(54, 162, 235, 0.6)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: 'Magnitude Range'
            }
          },
          y: {
            title: {
              display: true,
              text: 'Count'
            },
            beginAtZero: true
          }
        }
      }
    });
  }
  getColorByDepth(depth) {
    const minDepth = 0;
    const maxDepth = 200; // Use a reasonable max depth for normalization
    const normalized = Math.min(Math.max(depth, minDepth), maxDepth) / maxDepth;


    const hue = (1 - normalized) * 303;
    return `hsl(${hue}, 70%, 70%)`;
  }
}