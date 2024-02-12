const timerElement = document.getElementById('timer');
const startButton = document.getElementById('start');
const stopButton = document.getElementById('stop');
const resetButton = document.getElementById('reset');
const lapButton = document.getElementById('lap');

let startTime;
let elapsedTime = 0;
let lapTimes = [];

let intervalId;

const taskLists = {
  task1: document.getElementById('task1-list'),
  task2: document.getElementById('task2-list'),
  task3: document.getElementById('task3-list'),
};

startButton.addEventListener('click', () => {
  startTime = Date.now();
  intervalId = setInterval(updateTimer, 1);
});

stopButton.addEventListener('click', () => {
  clearInterval(intervalId);
});
let lastLapTime = 0; // 追加: 前回のラップタイムを保存する変数

lapButton.addEventListener('click', () => {
  const now = Date.now();
  const lapTime = now - startTime - elapsedTime - lastLapTime; // 変更: 前回のラップタイムを引く
  lastLapTime = now - startTime - elapsedTime; // 追加: 現在のラップタイムを保存
  lapTimes.push(lapTime);
  updateLapTimes();
  updateTaskTimes();
});

resetButton.addEventListener('click', () => {
  elapsedTime = 0;
  lapTimes = [];
  lastLapTime = 0; // 追加: リセットボタンが押されたときに前回のラップタイムもリセット
  updateTimer();
  updateTaskTimes();
});
function updateTimer() {
    const elapsedMilliseconds = Date.now() - startTime + elapsedTime;
    const hours = Math.floor(elapsedMilliseconds / 3600000);
    const minutes = Math.floor((elapsedMilliseconds % 3600000) / 60000);
    const seconds = Math.floor((elapsedMilliseconds % 60000) / 1000);
    timerElement.textContent = `time:${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }
  
  function updateLapTimes() {
    const lapListElement = document.getElementById('lap-list');
    const h2Elements = document.querySelectorAll('h2'); // 全てのh2タグを取得
    lapListElement.innerHTML = '';
    for (let i = 0; i < lapTimes.length; i++) { // lapTimesのインデックスも取得
      const lapTime = lapTimes[i];
      const lapItemElement = document.createElement('li');
      const hours = Math.floor(lapTime / 3600000);
      const minutes = Math.floor((lapTime % 3600000) / 60000);
      const seconds = Math.floor((lapTime % 60000) / 1000);
      const lapTimeStr = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
      lapItemElement.textContent = lapTimeStr;
      lapListElement.appendChild(lapItemElement);
      if (h2Elements[i]) { // h2タグが存在する場合のみ
        // h2タグの文字列の末尾がラップタイムの文字列でない場合は追加
        if (!h2Elements[i].textContent.endsWith(lapTimeStr)) {
          h2Elements[i].textContent += ` / ${lapTimeStr}`;
        }
      }
    }
  }